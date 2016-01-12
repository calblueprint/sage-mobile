package blueprint.com.sage.shared.interfaces;

import java.util.List;

import blueprint.com.sage.models.School;

/**
 * Created by charlesx on 11/23/15.
 */
public interface SchoolsInterface {
    List<School> getSchools();
    void setSchools(List<School> schools);
    void getSchoolsListRequest();

    void setNewSchool(School school);
    void setUpdatedSchool(School school);
}
