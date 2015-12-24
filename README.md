# stock_checker

Ruby scraper to check for changes on the stock status of products from the online shop SportsDirect.com. **Weekend  pet project, developed to help a friend.**

The input comes from a remote .csv file (hosted on Dropbox, for example), one product URL per line.

The output is sent by email, as a formatted diff.

## How it works

There is a class `Parser` that goes into each individual product webpage. All the data  we need from a product (colors, sizes, prices and stock status) is already stored in a JSON format on the page. `Converter` converts this complicated JSON into a data structure easier to work with, remmoving unnecessary attributes. This simpler data structure is stored in a file, and later retrieved (`Storage`), to be checked for modifications (`Diff`). In case something has changed, an email is sent with the formatted diff (`Mailer`).


## Installation

Clone the repository and then execute:

    $ bundle


## Usage

Update the SMTP email configuration on `mailer.rb`.

Update the input URL on `bin/stock_checker`.

Set up a cron job to execute `bin/stock_checker --email <EMAIL>`. You can also pass `--dry-run` for debugging purposes, so no emails or files are modified. 

