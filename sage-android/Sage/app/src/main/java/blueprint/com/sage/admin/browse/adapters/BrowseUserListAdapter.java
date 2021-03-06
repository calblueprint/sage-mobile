package blueprint.com.sage.admin.browse.adapters;

import android.support.v4.app.FragmentActivity;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.main.fragments.UserFragment;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.adapters.models.AbstractUserListAdapter;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/25/16.
 */
public class BrowseUserListAdapter extends AbstractUserListAdapter {

    public BrowseUserListAdapter(FragmentActivity activity, List<User> users) {
        super(activity, users);
        setUpUsers(users);
    }

    public void setUpUsers(List<User> users) {
        List<Item> allUsers = new ArrayList<>();
        List<Item> inactiveUsers = new ArrayList<>();

        for (User user : users) {
            Item item = new Item(user, null);
            allUsers.add(item);

            if (user.getUserSemester() != null && !user.getUserSemester().isActive())
                inactiveUsers.add(item);
        }

        mItemList = new ArrayList<>();

        if (inactiveUsers.size() != 0) {
            mItemList.add(new Item(null, "Inactive Users"));
            mItemList.addAll(inactiveUsers);
        }

        if (allUsers.size() != 0) {
            mItemList.add(new Item(null, "All Users"));
            mItemList.addAll(allUsers);
        }
    }

    public void onItemClick(User user) {
        FragUtils.replaceBackStack(R.id.container, UserFragment.newInstance(user), mActivity);
    }
}
