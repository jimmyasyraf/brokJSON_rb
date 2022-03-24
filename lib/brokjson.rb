class BrokJson
  def self.geo2brok(geojson)
    global_geometries = []
    global_properties = []
    global_foreign_members = []

    geojson['features'].each do |feature|
      next if feature['type'].downcase != 'feature'

      return unless feature.key?('geometry')

      # Add properties
      props = []
      if feature.key?('properties')
        feature['properties'].each do |property_key, property_value|
          # Add to list if item in list
          global_properties << property_key unless global_properties.include? property_key

          index = global_properties.find_index(property_key)

          # Check if props are long enough
          props = props + [nil] * (index + 1 - props.length) if props.length - 1 < index
          
          # Add to props
          props[index] = property_value
        end
      end

      # Add foreign members
      foreign_members = []
      feature.each do |item_key, item_val|
        next if ['type', 'properties', 'geometry'].include? item_key.downcase

        global_foreign_members << item_key unless global_foreign_members.include? item_key

        index = global_foreign_members.find_index(item_key)

        foreign_members = foreign_members + [nil] * (index + 1 - foreign_members.length) if foreign_members.length - 1 < index

        foreign_members[index] = item_val
      end

      coords = nil
      if feature['geometry']['type'].downcase == 'geometrycollection'
        # GeometryCollection detected!
        coords = []

        feature["geometry"]["geometries"].each do |geom|
          # Now check if last item of geometries is same type. If not, add the type
          if (coords.length == 0 || coords[-1]['type'].downcase != geom['type'].downcase)
            # Add new geometry list
            coords << { 'type' => geom['type'], 'features' => [] }
          end

          # Add feature to geometry list
          coords[coords.length - 1]['features'] << [geom['coordinates']]
        end
      else
        # Add Coords
        coords = feature['geometry']['coordinates']
      end

      # Create feature-array
      brok_feature = [coords]

      # Add props
      brok_feature << props if props.length > 0

      # Add foreign members
      if foreign_members.length > 0
        brok_feature << nil if brok_feature.length < 2
        brok_feature << foreign_members
      end

      # Now check if last item of geometries is same type. If not, add the type
      if (global_geometries.length == 0 || global_geometries[-1]['type'].downcase != feature['geometry']['type'].downcase)
        # Add new geometry list
        global_geometries << { 'type' => feature['geometry']['type'], 'features' => [] }
      end

      # Add feature to geometry list
      global_geometries[global_geometries.length - 1]['features'] << brok_feature
    end

    # Build BrokJSON
    brok = {}

    # Add global properties
    brok['properties'] = global_properties if global_properties.length > 0

    # Add foreign members
    brok['foreignMembers'] = global_foreign_members if global_foreign_members.length > 0

    # Add all unknown members
    geojson.each do |member_key, member_val|
      # Exclude List
      next if ['type', 'features'].include? member_key

      brok[member_key] = member_val
    end

    # Add geometry
    brok['geometries'] = global_geometries if global_geometries.length > 0

    return brok
  end

  def self.brok2geo(brok)
    geo = {
      'type' => 'FeatureCollection'
    }

    # Look for custom properties on root
    brok.each do |member_key, member_val|
      geo[member_key] = member_val unless ['properties', 'geometries', 'foreignMembers'].include? member_key
    end

    geo['features'] = [] if brok['geometries'].length > 0

    # Add geometries
    brok['geometries'].each do |geometry_collection|
      geometry_collection['features'].each do |feature|
        # Create Feature
        json_feature = { 'type' => 'Feature' }

        # Check and add properties
        properties = {}
        if feature.length >= 2
          (0..feature[1].length).each do |p|
            prop = feature[1][p]

            next if prop.nil?

            properties[brok['properties'][p]] = prop
          end
        end

        # Check and add foreign members
        if feature.length >= 3
          (0..feature[2].length).each do |m|
            json_feature[brok['foreignMembers'][m]] = feature[2][m]
          end
        end

        # Add props
        json_feature['properties'] = properties if properties.length > 0

        # Check if geometry collection
        if geometry_collection['type'].downcase == 'geometryCollection'
          new_coords = []
          geometry_collection['features'].each do |coordinates|
            coordinates[0].each do |geocol|
              geocol['features'].each do |types|
                coord = { 'type' => geocol['type'], 'coordinates' => types[0] }
                new_coords << coord
              end
            end
          end

          # Add Geometry
          json_feature['geometry'] = { 'type' => geometry_collection['type'], 'geometries' => new_coords }
        else
          # Normal Geometry
          json_feature['geometry'] = { 'type' => geometry_collection['type'], 'coordinates' => feature[0] }
        end

        geo['features'] << json_feature
      end
    end

    return geo
  end
end