package blueprint.com.sage.network.serializers;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

import blueprint.com.sage.models.User;

/**
 * Created by charlesx on 12/10/15.
 */
public class UserSerializer extends JsonSerializer<User> {

    private int id;
    private String email;
    private boolean verified;
    private String firstName;
    private String lastName;
    private int schoolId;
    private int directorId;
    private String role;
    private String volunteerType;
    private int totalHours;
    private String password;
    private String currentPassword;
    private String confirmPassword;
    private String imageUrl;
    private boolean active;

    @Override
    public void serialize(User user, JsonGenerator jgen, SerializerProvider provider)
            throws IOException {
        jgen.writeStartObject();

        jgen.writeNumberField("id", user.getId());
        jgen.writeStringField("email", user.getEmail());
        jgen.writeBooleanField("verified", user.isVerified());
        jgen.writeStringField("first_name", user.getFirstName());
        jgen.writeStringField("last_name", user.getLastName());

        jgen.writeEndObject();
    }
}
