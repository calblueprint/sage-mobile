package blueprint.com.sage.users.info.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.UserSemester;
import lombok.Data;

/**
 * Created by charlesx on 1/17/16.
 */
public class UserCheckInListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private Activity mActivity;
    private List<Item> mItems;
    private UserSemester mUserSemester;

    private static final int HEADER_VIEW = 0;
    private static final int CHECK_IN_VIEW = 1;

    public UserCheckInListAdapter(Activity activity, UserSemester userSemester) {
        super();

        mActivity = activity;
        mUserSemester = userSemester;
        mItems = new ArrayList<>();

        setUpCheckIn(mUserSemester);
    }

    private void setUpCheckIn(UserSemester userSemester) {
        if (userSemester == null) {
            return;
        }

        mItems.add(new Item(HEADER_VIEW, null));

        for (CheckIn checkIn : userSemester.getCheckIns())
            mItems.add(new Item(CHECK_IN_VIEW, checkIn));
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater =  LayoutInflater.from(mActivity);

        switch (viewType) {
            case HEADER_VIEW:
                return new HeaderViewHolder(inflater.inflate(R.layout.check_in_header, parent, false));
            case CHECK_IN_VIEW:
                return new HeaderViewHolder(inflater.inflate(R.layout.check_in_list_item, parent, false));
            default:
                Log.e(getClass().toString(), "Invalid header type");
                return null;
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        if (getItemCount() == 0 || position < 0 || position >= getItemCount())
            return;
    }

    @Override
    public int getItemCount() { return mItems.size(); }

    @Override
    public int getItemViewType(int position) {
        return mItems.get(position).getType();
    }

    public void setCheckIns(UserSemester userSemester) {
        setUpCheckIn(userSemester);
    }

    static class HeaderViewHolder extends RecyclerView.ViewHolder {
        public HeaderViewHolder(View v) {
            super(v);
        }
    }

    static class ListViewHolder extends RecyclerView.ViewHolder {
        public ListViewHolder(View v) {
            super(v);
        }
    }

    @Data
    private static class Item {
        private int type;
        private CheckIn checkIn;

        public Item(int type, CheckIn checkIn) {
            this.type = type;
            this.checkIn = checkIn;
        }
    }
}
