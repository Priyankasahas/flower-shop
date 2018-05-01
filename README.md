# Cogent's Developer Coding Test
Rails 5.1.6
Ruby 2.3.3

## Context
A flower shop used to base the price of their flowers on an item by item cost. So if a customer ordered 10 roses then they would be charged 10x the cost of single rose. The flower shop has decided to start selling their flowers in bundles and charging the customer on a per bundle basis. So if the shop sold roses in bundles of 5 and 10 and a customer ordered 15 they would get a bundle of 10 and a bundle of 5.

The flower shop currently sells the following products:
* Roses R12 5 @ $6.99
* Roses R12 10 @ $12.99

* Lilies L09 3 @ $9.95
* Lilies L09 6 @ $16.95
* Lilies L09 9 @ $24.95

* Tulips T58 3 @ $5.95
* Tulips T58 5 @ $9.95
* Tulips T58 9 @ $16.95

## Task
Given a customer order you are required to determine the cost and bundle breakdown for each product. To save on shipping space each order should contain the minimal number of bundles.

## Input
Each order has a series of lines separated by comma with each line containing the number of items followed by the product code:
E.g. 10 R12, 15 L09, 13 T58

## The Solution
Use `rake flower_shop:order` to run the program.

You will be asked to input each order has a series of lines separated by comma with each line containing the number of items followed by the product code:
E.g. 10 R12, 15 L09, 13 T58

You will need to enter a valid input within 4 trials.

Once a valid input is detected, it initiates the application and processes the input in order to display the order receipt.

Here I have tried to focus on classes to have a single responsibility.

CliService - This is an example of wrapper class for an external cli service.

OrderingTool - Initiates the ordering process.

Shop - responsible for checking the validity of the input and processing valid input to provide the required output.

OrderProcessor - Splits the quantity into bundles and returns the bundled result and/or error message if the quantity can't be bundled.

OrderReceipt - Generates and structures the receipt for output.

## Database
Run rake db:setup
* Creates flower_shop(development) database and flower_shop_test(test) database
* Runs migration to create catalogue_bundles table
* Seeds catalogue_bundles table


Use `rspec` to run the tests

Use `rubocop` to check if the code aligns with Ruby best practices
