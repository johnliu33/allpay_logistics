require 'net/http'
require 'json'
require 'cgi'
require 'digest'
require 'allpay/errors'
require 'allpay/core_ext/hash'
#require 'awesome_print'
require 'byebug'

module Allpay
  class Client
    PRODUCTION_API_HOST = 'https://logistics.allpay.com.tw/Express/map'.freeze
    TEST_API_HOST = 'http://logistics-stage.allpay.com.tw/Express/map'.freeze
    TEST_OPTIONS = {
      merchant_id: '2000933', #, '2000132'
      hash_key: 'XBERn1YOvpM9nfZc',  #,'5294y06JbISpM5x9'
      hash_iv:  'h1ONHk4P4yqbl5LK'  # 'v77hoKGq4kWxNNIS'
    }.freeze

    attr_reader :options

    def initialize options = {}
      @options = {mode: :production}.merge!(options)
      case @options[:mode]
      when :production
        option_required! :merchant_id, :hash_key, :hash_iv
      when :test
        @options = TEST_OPTIONS.merge(options)
      else
        raise InvalidMode, %Q{option :mode is either :test or :production}
      end
      @options.freeze
    end

    def api_host
      case @options[:mode]
      when :production then PRODUCTION_API_HOST
      when :test then TEST_API_HOST
      end
    end

    def make_mac params = {}
      raw = params.sort_by{|k,v|k.downcase}.map!{|k,v| "#{k}=#{v}"}.join('&')
      padded = "HashKey=#{@options[:hash_key]}&#{raw}&HashIV=#{@options[:hash_iv]}"
      url_encoded = CGI.escape(padded).downcase!
      Digest::MD5.hexdigest(url_encoded).upcase!
    end

    def verify_mac params = {}
      stringified_keys = params.stringify_keys
      check_mac_value = stringified_keys.delete('CheckMacValue')
      make_mac(stringified_keys) == check_mac_value
    end

    def generate_params overwrite_params = {}
      result = overwrite_params.clone
      result[:MerchantID] = @options[:merchant_id]
      result[:CheckMacValue] = make_mac(result)
      result
    end

    def generate_checkout_params overwrite_params = {}
      r = generate_params({
        # MerchantTradeDate: Time.now.strftime('%Y/%m/%d %H:%M:%S'),
        # MerchantTradeNo: SecureRandom.hex(4),
        # PaymentType: 'aio'
      }.merge!(overwrite_params))

      puts r
      return r
    end

    def request path, params = {}
      api_url = URI.join(api_host, path)
      Net::HTTP.post_form api_url, generate_params(params)
    end

    def query_trade_info merchant_trade_number, platform = nil
      params = {
        MerchantTradeNo: merchant_trade_number,
        TimeStamp: Time.now.to_i,
        PlatformID: platform
      }
      params.delete_if{ |k, v| v.nil? }
      res = request '/Cashier/QueryTradeInfo', params
      Hash[res.body.split('&').map!{|i| i.split('=')}]
    end

    def cancel_logistics_order logistics_id, cvs_payment_no, cvs_validation_no, platform = nil #物流下單取消
      params = {
        AllPayLogisticsID: logistics_id,
        CVSPaymentNo: cvs_payment_no,
        CVSValidationNo: cvs_validation_no
      }
      params.delete_if{ |k, v| v.nil? }

      request '/Express/CancelC2COrder', params
    end

    def query_logistics_trade_info logistics_id, platform = nil #物流狀況查詢
      params = {
        AllPayLogisticsID: logistics_id,
        TimeStamp: Time.now.to_i,
        PlatformID: platform
      }
      params.delete_if{ |k, v| v.nil? }
      res = request '/Helper/QueryLogisticsTradeInfo', params
      Hash[res.body.split('&').map!{|i| i.split('=')}]
    end

    def query_period_credit_card_trade_info merchant_trade_number
      res = request '/Cashier/QueryPeriodCreditCardTradeInfo',
              MerchantTradeNo: merchant_trade_number,
              TimeStamp: Time.now.to_i
      JSON.parse(res.body)
    end

    private

    def option_required! *option_names
      option_names.each do |option_name|
        raise MissingOption, %Q{option "#{option_name}" is required.} if @options[option_name].nil?
      end
    end
  end
end
