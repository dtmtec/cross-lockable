module CrossLockable
  module TokenGenerator
    require 'digest/sha1'

    def self.generate_security_token(timestamp = Time.now, random = Kernel.rand)
      timestamp = timestamp.to_i.to_s
      random    = random.to_s.gsub('.', '')[0..9]

      timestamp + random + Digest::SHA1.hexdigest(timestamp + random + CrossLockable.lockable_secret)
    end

    def self.valid_token?(token)
      token == generate_security_token(token[0..9], token[10..19])
    end
  end
end