package blueprint.com.sage.network.serializers;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

import blueprint.com.sage.models.School;

/**
 * Created by charlesx on 11/17/15.
 */
public class SchoolSerializer extends JsonSerializer<School> {
    @Override
    public void serialize(School school, JsonGenerator jgen, SerializerProvider provider)
            throws IOException {
        jgen.writeStartObject();
        jgen.writeNumberField("id", school.getId());
        jgen.writeStringField("name", school.getName());
        jgen.writeStringField("address", school.getAddress());
        jgen.writeNumberField("lat", school.getLat());
        jgen.writeNumberField("lng", school.getLng());
        jgen.writeNumberField("director_id", school.getDirectorId());
        jgen.writeEndObject();
    }
}
