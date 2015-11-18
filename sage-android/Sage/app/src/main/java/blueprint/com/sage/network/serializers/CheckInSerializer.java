package blueprint.com.sage.network.serializers;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

import blueprint.com.sage.models.CheckIn;

/**
 * Created by charlesx on 10/31/15.
 */
public class CheckInSerializer extends JsonSerializer<CheckIn> {

    @Override
    public void serialize(CheckIn checkIn, JsonGenerator jgen, SerializerProvider provider)
            throws IOException {
        jgen.writeStartObject();

        jgen.writeStringField("start", checkIn.getStart().toString());
        jgen.writeStringField("finish", checkIn.getFinish().toString());
        jgen.writeNumberField("user_id", checkIn.getUser_id());
        jgen.writeNumberField("school_id", checkIn.getSchool_id());

        if (checkIn.getComment() != null && !checkIn.getComment().isEmpty()) {
            jgen.writeStringField("comment", checkIn.getComment());
        }

        jgen.writeEndObject();
    }
}
