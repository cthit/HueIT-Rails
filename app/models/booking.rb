# == Schema Information
#
# Table name: bookings
#
#  id          :integer          not null, primary key
#  user_id     :string(255)
#  begin_date  :datetime
#  end_date    :datetime
#  group       :string(255)
#  description :text(65535)
#  room_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  title       :string(255)
#  phone       :string(255)
#  deleted_at  :datetime
#

class Booking < ActiveRecord::Base
  scope :by_group_or_user, -> (name) { where('user_id IN (?) OR `group` IN (?)', name, name) }
  scope :in_future, -> { where('end_date >= ?', DateTime.now) }
  scope :from_date, -> (time = 1.month.ago) { where('begin_date >= ?', time) }
  scope :within, -> (time = 1.month.from_now) { where('begin_date <= ?', time) }
  scope :in_room, -> (room) { where(room: room) }

  belongs_to :room, touch: true
  belongs_to :user

  has_one :party_report, dependent: :destroy, inverse_of: :booking

  acts_as_paranoid # make destroy -> logical delete

  accepts_nested_attributes_for :party_report

  before_validation :format_phone # remove any non-numeric characters

  validate :must_be_party_room, if: 'party_report.present?'

  # essential validations
  validates :title, :description, :user, :room, :begin_date, :end_date, presence: true
  validates :phone, presence: true,length: { minimum: 6 }

  validate :must_be_allowed
  validate :must_not_exceed_max_duration, :must_not_collide, :must_be_group_in_room

  validates_datetime :begin_date, after: -> { DateTime.now.beginning_of_day }
  validates_datetime :end_date, after: :begin_date


  def user
    @user ||= User.find(self.user_id)
  end

  def group_sym
    group.to_sym
  end

  def status_text
    if party_report && party_report.accepted
      if party_report && party_report.sent?
        return 'Godkänd och skickad till Chalmers'
      else
        return 'Godkänd, ej skickad till Chalmers'
      end
    elsif party_report && party_report.accepted.nil?
      return 'Väntar på godkännande av VO'
    else
      return 'Avslagen'
    end
  end

  DATE_AND_TIME = '%-d %b %R' # example: 4 apr 12:00

  def booking_range
    ary = [I18n.localize(begin_date, format: DATE_AND_TIME)]
    if same_day?(begin_date, end_date)
      ary << I18n.localize(end_date, format: '%R') # example: 09:00
    else
      ary << I18n.localize(end_date, format: DATE_AND_TIME)
    end
    ary.join ' - '
  end

  private

    def same_day?(d1, d2)
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day
    end

    def format_phone
      self.phone.gsub!(/[^0-9]/, '') if self.phone
    end

    def must_be_party_room # called if party
      errors.add(:room, 'tillåter ej festbokningar') unless room.allow_party
    end

    def must_be_group_in_room
      unless group.present?
        errors.add(:room, 'kan ej bokas som privatperson') if room.only_group
      else
        errors.add(:group, 'är du ej medlem i') unless user.in_group? group.to_sym
      end
    end

    def must_not_collide
      Booking.in_room(self.room).in_future.each do |b|
        unless b == self
          # Algorithm source: http://makandracards.com/makandra/984-test-if-two-date-ranges-overlap-in-ruby-or-rails
          if (begin_date - b.end_date) * (b.begin_date - end_date) > 0
            errors[:base] << 'Lokalen är redan bokad under denna perioden'
            return
          end
        end
      end
    end

    def must_not_exceed_max_duration
      unless begin_date.nil? || end_date.nil?
        days = (end_date - begin_date).to_i / 1.day
        msg = "Bokningen får ej vara längre än en vecka, (är #{days} dagar)"
        errors.add(:end_date, msg) if days > 7
      end
    end

    def must_be_allowed

      # Vi måste veta om bokningen täcker flera dagar för att kolla
      # tiden för regler. Säg bokning fre lör sön, så täcker ju bokninge all tid
      # på lördag, men ska ta hänsyn till bokningstiden olika för fre och sön
      # därav måste första och sista dagen hanteras annorlunda vid flerdagsbokningar
      # då det i första dagen gäller från bokningstart - 24:00
      # och sista dagen gäller från 00:00 - bokningsslut

      multi_day_booking = ((end_date.to_date - begin_date.to_date).to_i) > 0

      rules = Rule.in_room(room).in_range(begin_date, end_date).order(:prio)

      res = if multi_day_booking
        check_multi_day_booking(rules)
      else
        check_single_day_booking(begin_date, end_date, rules)
      end

      res.each do |rule|
        errors.add(:rule, rule.reason)
      end
    end

    def check_single_day_booking(b_date, e_date, rules)
      # rule just contains times, we must translate its date to the booking day
      date = b_date.to_date
      day_rules = rules.map{ |rule| rule.with_date!(date) }.select{ |rule| rule.applies?(date.wday) }

      Rule.merge(day_rules).select do |rule|
        start, stop, rule = rule
        !rule.allow && (start - e_date) * (b_date - stop) > 0
      end.map { |rule| rule.last }
    end

    def check_multi_day_booking(rules)
      ((begin_date.to_date)..(end_date.to_date)).each do |day|
        collisions = collides?(day, rules)
        return collisions if collisions.any?
      end
      return []
    end

    def collides?(day, rules)
      # first_day_collision?
      return check_single_day_booking(begin_date, day.end_of_day, rules) if day == begin_date.to_date
      # last_day_collision?
      return check_single_day_booking(day.midnight, end_date, rules) if day == end_date.to_date
      # middle_day_collision?
      return check_single_day_booking(day.midnight, day.end_of_day, rules)
    end

end
