# stock_checker

Ruby scraper to check for changes on the stock status of products from the online shop SportsDirect.com. **Weekend  pet project. Use at your own risk**

The input comes from a remote .csv file (hosted on Dropbox, for example), one product URL per line.

The output is generated as a HTML report, which should be available in a web server. The URL is sent by email to the user.

## How it works

There is a class `Parser` that goes into each individual product webpage. All the data  we need from a product (colors, sizes, prices and stock status) is already stored in a JSON format on the page. `Converter` converts this complicated JSON into a data structure (`Product` and `Item`) easier to work with, removing unnecessary attributes. This simpler data structure is stored in a file, and later retrieved (`Storage`), to be checked for modifications (`Comparator`). In case something has changed, a report is generated (`Report`) and an email is sent with the URL ofthe report (`Mailer`).


## Installation

Clone the repository and then execute:

    $ bundle


## Usage

Update the SMTP email configuration on `mailer.rb`. Create a symbolic link of `reports/output` in your WWW public folder and add the URL prefix on `report.rb` so the correct link is properly sent my email.

Set up a cron job to execute `bin/stock_checker --email <EMAIL> --url <URL>`. You can also pass `--dry-run` for debugging purposes, so no emails or files are modified. 

