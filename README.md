# stock_checker

Ruby scraper to check for changes on the stock status of products from the online shop SportsDirect.com. **Weekend  pet project. Use at your own risk**

The input comes from a remote .csv file (hosted on Dropbox, for example), one product URL per line.

The output is generated as a HTML report, which should be available in a web server. The URL is sent by email to the user.

## How it works

There is a class `Parser` that goes into each individual product webpage. All the data  we need from a product (colors, sizes, prices and stock status) is already stored in a JSON format on the page. `Converter` converts this complicated JSON into a data structure (`Product` and `Item`) easier to work with, removing unnecessary attributes. This simpler data structure is stored in a file, and later retrieved (`Storage`), to be checked for modifications (`Comparator`). In case something has changed, a report is generated (`Report`) and an email is sent with the URL ofthe report (`Mailer`).

By default, prices from SportsDirect are in GBP, but it can be changed on the website. We send cookies on the `Parser` to have prices in EUR.

Notifications have priorities that are used to sort products on the report. We show the removed and readded products first.

## Installation

Clone the repository and then execute:

    $ bundle


## Usage

Update the SMTP email configuration on `mailer.rb`. Create a symbolic link of `reports/output` in your WWW public folder and add the URL prefix on `report.rb` so the correct link is properly sent my email.

For example, set up a cron job to execute `bin/stock_checker --email <EMAIL> --url <URL>`. You can also pass `--dry-run` for debugging purposes, so no emails or files are modified. 

Working example (from the `bin/` folder):

    $ ./stock_checker -d -u https://dl.dropboxusercontent.com/u/9598149/products.csv

