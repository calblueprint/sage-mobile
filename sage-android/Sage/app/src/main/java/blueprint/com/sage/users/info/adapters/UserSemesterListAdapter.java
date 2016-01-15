package blueprint.com.sage.users.info.adapters;

import android.support.v4.app.FragmentActivity;
import android.view.View;

import java.util.List;

import blueprint.com.sage.models.Semester;
import blueprint.com.sage.shared.adapters.models.AbstractSemesterListAdapter;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/15/16.
 */
public class UserSemesterListAdapter extends AbstractSemesterListAdapter {
    public UserSemesterListAdapter(FragmentActivity activity, List<Semester> semesters) {
        super(activity, semesters);
    }

    public void onItemClicked(View view, Semester semester) {
        FragUtils.replaceBackStack(view, );
    }
}
