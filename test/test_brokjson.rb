require 'test/unit'
require 'brokjson'

class BrokJsonTest < Test::Unit::TestCase
  def test_can_convert_from_geojson_to_brokjson
    assert_equal sample_brokjson, BrokJson.geo2brok(sample_geojson)
  end

  def test_can_convert_from_brokjson_to_geojson
    assert_equal sample_geojson, BrokJson.brok2geo(sample_brokjson)
  end

  private

  def sample_geojson
    {
      'type' => 'FeatureCollection',
      'title' => 'Hello World',
      'features' => [
        {
          'type' => 'Feature',
          'properties' => {
            'id' => 1,
            'title' => 'Datapoint 1',
            'value' => 343
          },
          'geometry' => {
            'type' => 'Point',
            'coordinates' => [
              8.5402,
              47.3782
            ]
          }
        },
        {
          'type' => 'Feature',
          'properties' => {
            'id' => 1,
            'title' => 'Datapoint 2',
            'value' => 14
          },
          'geometry' => {
            'type' => 'Point',
            'coordinates' => [
              8.5637,
              47.4504
            ]
          }
        }
      ]
    }
  end

  def sample_brokjson
    {
      'properties' => [
        'id',
        'title',
        'value'
      ],
      'title' => 'Hello World',
      'geometries' => [
        {
          'type' => 'Point',
          'features'=> [
            [
              [8.5402, 47.3782],
              [1, 'Datapoint 1', 343]
            ],
            [
              [8.5637, 47.4504],
              [1, 'Datapoint 2', 14]
            ]
          ]
        }
      ]
    }
  end
end
