package blueprint.com.sage.serializers;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

import blueprint.com.sage.models.User;

/**
 * Created by charlesx on 10/23/15.
 */
public class UserSerializer extends JsonSerializer<User> {

    @Override
    public void serialize(User user, JsonGenerator jgen, SerializerProvider provider) throws IOException {
        jgen.writeStartObject();
        jgen.writeStringField("email", user.getEmail());
        jgen.writeStringField("first_name", user.getFirstName());
        jgen.writeStringField("last_name", user.getLastName());
        jgen.writeStringField("password", user.getPassword());
//        jgen.writeStringField("current_password", user.getPassword());
        jgen.writeNumberField("school_id", user.getSchoolId());
        jgen.writeNumberField("role", 0);
        jgen.writeNumberField("volunteer_type", user.getVolunteerTypeString());
        if (user.getProfileData() != null) {
            jgen.writeStringField("data", user.getProfileData());
        }
        jgen.writeEndObject();
    }
}
