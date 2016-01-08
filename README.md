<!--[![Build Status](https://travis-ci.org/tonytonyjan/allpay.svg?branch=master)](https://travis-ci.org/tonytonyjan/allpay)
-->
# Allpay Logistics 歐付寶

這是歐付寶物流的 API 的 Ruby 包裝，是參考[tonytonyjan](https://github.com/tonytonyjan)的[https://github.com/tonytonyjan/allpay](https://github.com/tonytonyjan/allpay)改寫成的，更多資訊參考歐付寶的[官方文件](https://www.allpay.com.tw/Content/files/allpay_030.pdf)。

- 這不是 Rails 插件，只是個 API 包裝。
<!--- 使用時只需要傳送需要的參數即可，不用產生檢查碼，`allpay_client` 會自己產生。
- 錯誤代碼太多且會不斷增加，筆者不另行撰寫，官方也建議查網站上的代碼清單。
-->
## 安裝

```bash
gem install allpay_logistics_client
```

<!--## 使用

```ruby
test_client = Allpaylogistics::Client.new(mode: :test)
production_client = Allpaylogistics::Client.new({
  merchant_id: 'MERCHANT_ID',
  hash_key: 'HASH_KEY',
  hash_iv: 'HASH_IV'
})

test_client.request '/Cashier/QueryTradeInfo',
  MerchantTradeNo: '0457ce27',
  TimeStamp: Time.now.to_i
```

歐付寶共有 5 個 API：

- /Cashier/AioCheckOut
- /Cashier/QueryTradeInfo
- /Cashier/QueryPeriodCreditCardTradeInfo
- /CreditDetail/DoAction
- /Cashier/AioChargeback

每個 API 有哪些參數建議直接參考歐付寶文件，注意幾點：

- 使用時不用煩惱 `MerchantID` 與 `CheckMacValue`，正如上述範例一樣。
- `/Cashier/AioCheckOut` 回傳的內容是 HTML，這個請求應該是交給瀏覽器發送的，所以不應該寫出 `client.request '/Cashier/AioCheckOut'` 這樣的內容。

## Allpaylogistics::Client

實體方法                                                     | 回傳                | 說明
---                                                          | ---                 | ---
`request(path, **params)`                                    | `Net::HTTPResponse` | 發送 API 請求
`make_mac(**params)`                                         | `String`            | 用於產生 `CheckMacValue`，單純做加密，`params` 需要完整包含到 `MerchantID`
`verify_mac(**params)`                                       | `Boolean`           | 會於檢查收到的參數，其檢查碼是否正確，這用在歐付寶物的 `ReturnURL` 與 `PeriodReturnURL` 參數上。
`query_trade_info(merchant_trade_number, platform = nil)`    | `Hash`              | `/Cashier/QueryTradeInfo` 的捷徑方法，將 `TimeStamp` 設定為當前時間
`query_period_credit_card_trade_info(merchant_trade_number)` | `Hash`              | `/Cashier/QueryPeriodCreditCardTradeInfo` 的捷徑方法，將 `TimeStamp` 設定為當前時間
`generate_checkout_params`                                   | `Hash`              | 用於產生 `/Cashier/AioCheckOut` 表單需要的參數，`MerchantTradeDate`、`MerchantTradeNo`、`PaymentType`，可省略。-->

## 使用範例

```bash
git clone git@github.com:johnliu33/allpay_logistics.git
cd allpay_logistics
bundle install
ruby examples/server.rb
```