CatalogueBundle.destroy_all

CatalogueBundle.create!([{
  name: 'Roses',
  code: 'R12',
  quantity: 5,
  price: 6.99
},
{
  name: 'Roses',
  code: 'R12',
  quantity: 10,
  price: 12.99
},
{
  name: 'Lilies',
  code: 'L09',
  quantity: 3,
  price: 9.95
},
{
  name: 'Lilies',
  code: 'L09',
  quantity: 6,
  price: 16.95
},
{
  name: 'Lilies',
  code: 'L09',
  quantity: 9,
  price: 24.95
},
{
  name: 'Tulips',
  code: 'T58',
  quantity: 3,
  price: 5.95
},
{
  name: 'Tulips',
  code: 'T58',
  quantity: 5,
  price: 9.95
},
{
  name: 'Tulips',
  code: 'T58',
  quantity: 9,
  price: 16.99
}])

p "Created #{CatalogueBundle.count} bunldes"
