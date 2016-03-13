package blueprint.com.sage.main.filters;

import android.widget.RadioButton;

import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 3/8/16.
 */
public class AnnouncementsAllFilter extends Filter {

    private User mUser;
    private School mSchool;

    public AnnouncementsAllFilter(RadioButton radioButton, User user, School school) {
        super(radioButton);
        mUser = user;
        mSchool = school;
    }

    public String getFilterKey() {
        return mUser.isAdmin() ? ""  : "default";
    }

    public String getFilterValue() {
        return mUser.isAdmin() || mSchool == null ? "" : "" + mSchool.getId();
    }
}
