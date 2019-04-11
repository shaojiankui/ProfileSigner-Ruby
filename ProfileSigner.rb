require 'openssl'

$:.unshift(File.dirname(__FILE__) + "/plist/lib")
require 'plist'

# http://UUIDTools.rubyforge.org
$:.unshift(File.dirname(__FILE__) + "/uuidtools/lib")
require 'uuidtools'


$ssl_key_file = "ssl_private.pem"
$ssl_key = nil
$ssl_cert_file = "ssl_cert.pem"
$ssl_cert = nil

$exist_profile = "unsignedProfile.mobileconfig"


def init
    ssl_cert_ok = false
    
    begin
        $ssl_key = OpenSSL::PKey::RSA.new(File.read($ssl_key_file))
        $ssl_cert = OpenSSL::X509::Certificate.new(File.read($ssl_cert_file))
    end
end


def general_payload
    payload = Hash.new
    payload['PayloadVersion'] = 1 # do not modify
    payload['PayloadUUID'] = UUIDTools::UUID.random_create().to_s # should be unique

    # string that show up in UI, customisable
    payload['PayloadOrganization'] = "ACME Inc."
    payload
end


def profile_service_payload(url)
    payload = general_payload()

    payload['PayloadType'] = "Profile Service" # do not modify
    payload['PayloadIdentifier'] = "com.acme.mobileconfig.profile-service"

    # strings that show up in UI, customisable
    payload['PayloadDisplayName'] = "ACME Profile Service"
    payload['PayloadDescription'] = "Install this profile to enroll for secure access to ACME Inc."

    payload_content = Hash.new
    payload_content['URL'] = url
    payload_content['DeviceAttributes'] = [
        "UDID", 
        "VERSION"
=begin
        "PRODUCT",              # ie. iPhone1,1 or iPod2,1
        "MAC_ADDRESS_EN0",      # WiFi MAC address
        "DEVICE_NAME",          # given device name "iPhone"
        # Items below are only available on iPhones
        "IMEI",
        "ICCID"
=end
        ];
  
    payload['PayloadContent'] = payload_content
    puts(payload);
    Plist::Emit.dump(payload)
end
def gen(url)
#     #配置文件自动生成
#     configuration = profile_service_payload(url)
   # 读取已经存在的配置文件
    configuration = File.read($exist_profile)
    signed_profile = OpenSSL::PKCS7.sign($ssl_cert, $ssl_key, 
            configuration, [], OpenSSL::PKCS7::BINARY)

    File.open("unsignedProfile.mobileconfig", "w") { |f| f.write configuration }
    File.open("signedProfile.mobileconfig", "w") { |f| f.write signed_profile.to_der }
end


init()
gen('https://dev.skyfox.org/udid/receive.php')