# BrokJSON
Ever struggled with huge GeoJSON-Files? BrokJSON is your space-saving alternative! Depending on your data you can save up to 80%. **Withouth losing any data!** Why? Because it uses the same ideas as GeoJSON.
  
The idea behind BrokJSON: **RAM is mightier than the bandwidth** - download the small BrokJSON and convert it on runtime to GeoJSON than loading a huge GeoJSON.

## Example
This **GeoJSON** with just two Points...
```json
{
  "type": "FeatureCollection",
  "features": [
  {
    "type": "Feature",
    "properties": {
      "id": 1,
      "title": "Datapoint 1",
      "value": 343
    },
    "geometry": {
      "type": "Point",
      "coordinates": [8.5402,47.3782]
    }
  },
  {
    "type": "Feature",
    "properties": {
      "id": 1,
      "title": "Datapoint 2",
      "value": 14
    },
    "geometry": {
      "type": "Point",
      "coordinates": [8.5637,47.4504]
    }
  }]
}
```
... looks as a **BrokJSON** like this:

```json
{
  "properties": ["id", "title", "value"],
  "geometries": [{
    "type": "Point",
    "features": [
      [[8.5402, 47.3782], [1, "Datapoint 1", 343]],
      [[8.5637, 47.4504], [1, "Datapoint 2", 14]]
    ]
  }
]}
```
No information lost, everything is there. Amazing!

## Installation

```sh
gem install brokjson
```

or include it in your Gemfile:

```ruby
gem 'brokjson'
```

## Usage
```ruby
# import BrokJSON
require 'brokjson'

# Load your GeoJSON
geojson = {
  'type' => 'FeatureCollection',
  'features' => [
    {
      'type' => 'Feature',
      'geometry' => {
        'type' => 'Point',
        'coordinates' => [8.5402, 47.3782]
      }
    }
  ]
}

# Convert your GeoJson to BrokJson
brok = BrokJson.geo2brok(geojson)

# Convert it back
geojson = BrokJson.brok2geo(brok)
```
## Documentation
BrokJSON is a lightweight library, there are only two functions.
### GeoJSON to BrokJSON
```ruby
geo2brok(geoJsonObject)
```
**Parameters**  
`GeoJSON` as a `Ruby-Hash`

**Return value**  
`BrokJSON` as a `Ruby-Hash`

### BrokJSON to GeoJSON
```ruby
brok2geo(brokJsonObject)
```
**Parameters**  
`BrokJSON` as a `Ruby-Hash`

**Return value**  
`GeoJSON` as a `Ruby-Hash`


## Full Spec and other languages
Have a look at https://www.brokjson.dev
