$: << File.expand_path('../../lib', __FILE__)
require 'bundler/setup'
require 'sinatra'
require 'allpay'
require 'json'

set :bind, '10.0.1.202'
set :port, 3000



get '/' do  #超商物流下單
  client = Allpay::Client.new(mode: :test)
  @params = client.generate_checkout_params({
    MerchantTradeNo: SecureRandom.hex(4),
    LogisticsType: 'CVS',
    LogisticsSubType: 'UNIMARTC2C', #'UNIMARTC2C' 'FAMIC2C'
    IsCollection: 'Y',
    ServerReplyURL: 'http://27.105.102.4/notify',
    ExtraData: '',
    Device: 1
  })
  erb :index
end

get '/queryOrder' do #查詢物流狀況
  
  client = Allpay::Client.new(mode: :test)
  result_hash = client.query_logistics_trade_info '15311'
  byebug
  result_hash['AllPayLogisticsID'] + ',' + result_hash['LogisticsStatus']


end

get '/cancelC2COrder' do #超商退貨
    client = Allpay::Client.new(mode: :test)
    @params = client.generate_checkout_params({
    AllPayLogisticsID: '15306',
    CVSPaymentNo: 'F0020325',
    CVSValidationNo: '7137',
    PlatformID: ''
  })
  erb :cancelorder
end

get '/printUniC2COrderInfo' do  #列印統一物流單
  client = Allpay::Client.new(mode: :test)
  @params = client.generate_checkout_params({
    MerchantTradeNo: SecureRandom.hex(4),
    AllPayLogisticsID: '15311',
    CVSPaymentNo: 'F0020336',
    CVSValidationNo: '3998',
    PlatformID: ''
  })
  erb :printUniOrder
end

post '/notify' do
  
  @merchantId = params['MerchantID']
  @merchantTradeNo = params['MerchantTradeNo']
  @logisticsSubType = params['LogisticsSubType']
  @cvsStoreId = params['CVSStoreID']
  @cvsStoreName = params['CVSStoreName']
  @cvsAddress = params['CVSAddress']
  @cvsTelephone = params['CVSTelephone']

  client = Allpay::Client.new(mode: :test)
  @params = client.generate_checkout_params({
    MerchantID: @merchantId,
    MerchantTradeNo: @merchantTradeNo,
    MerchantTradeDate: Time.now.strftime('%Y/%m/%d %H:%M:%S'),
    LogisticsType: 'CVS',
    LogisticsSubType: @logisticsSubType,
    GoodsAmount: 1000,
    CollectionAmount: 1000,
    IsCollection: 'Y',
    GoodsName: '怪彈手機殼',
    SenderName: '劉立山',
    SenderPhone: '0228855867',
    SenderCellPhone: '0920241251',
    ReceiverName: '徐素玫',
    ReceiverPhone: '0228946819',
    ReceiverCellPhone: '0928223015',
    ReceiverEmail: 'johnliu33@gmail.com',
    TradeDesc: '',
    ServerReplyURL: 'http://27.105.102.4/expressReply',
    ClientReplyURL: 'http://27.105.102.4/clientReply',
    LogisticsC2CReplyURL: 'http://27.105.102.4/c2cReply',
    Remark: '',
    PlatformID: '',
    ReceiverStoreID: @cvsStoreId,
    ReturnStoreID: @csvStoreID
    })
  erb:createOrder
  
end

post '/expressReply' do
  
  logger.info params.inspect

  '1|OK'
  
end

post '/c2cReply' do

  logger.info params.inspect
end

post '/clientReply' do
  params.inspect
end