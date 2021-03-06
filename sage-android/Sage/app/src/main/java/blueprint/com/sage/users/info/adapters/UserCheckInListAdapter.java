package blueprint.com.sage.users.info.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import org.joda.time.DateTime;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.User;
import blueprint.com.sage.utility.model.CheckInUtils;
import blueprint.com.sage.utility.view.DateUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import lombok.Data;

/**
 * Created by charlesx on 1/17/16.
 */
public class UserCheckInListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private Activity mActivity;
    private List<Item> mItems;
    private User mUser;
    private List<CheckIn> mCheckIns;

    private static final int HEADER_VIEW = 0;
    private static final int CHECK_IN_VIEW = 1;

    private static final String COMPLETE = "Complete";
    private static final String INCOMPLETE = "Incomplete";

    public UserCheckInListAdapter(Activity activity, User user) {
        super();

        mActivity = activity;
        mUser = user;

        setUpCheckIn();
    }

    private void setUpCheckIn() {
        mItems = new ArrayList<>();
        mCheckIns = new ArrayList<>();

        if (mUser.getUserSemester() == null) {
            return;
        }

        mItems.add(new Item(HEADER_VIEW, null));

        if (mUser.getCheckIns() == null || mUser.getCheckIns().size() == 0) {
            return;
        }

        for (CheckIn checkIn : mUser.getCheckIns()) {
            if (checkIn.isVerified()) {
                mCheckIns.add(checkIn);
                mItems.add(new Item(CHECK_IN_VIEW, checkIn));
            }
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater =  LayoutInflater.from(mActivity);

        switch (viewType) {
            case HEADER_VIEW:
                return new HeaderViewHolder(inflater.inflate(R.layout.check_in_header, parent, false));
            case CHECK_IN_VIEW:
                return new ListViewHolder(inflater.inflate(R.layout.check_in_list_item, parent, false));
            default:
                Log.e(getClass().toString(), "Invalid header type");
                return null;
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        if (getItemCount() == 0 || position < 0 || position >= getItemCount())
            return;

        Item item = mItems.get(position);

        switch (item.getType()) {
            case HEADER_VIEW:
                setHeaderView((HeaderViewHolder) viewHolder);
                break;
            case CHECK_IN_VIEW:
                setListItemView((ListViewHolder) viewHolder, item.getCheckIn());
                break;
        }
    }

    private void setListItemView(ListViewHolder viewHolder, CheckIn checkIn) {
        viewHolder.mAt.setVisibility(View.GONE);
        viewHolder.mUserText.setVisibility(View.GONE);

        if (checkIn.getSchool() == null) {
            viewHolder.mSchoolText.setVisibility(View.GONE);
        } else {
            viewHolder.mSchoolText.setText(checkIn.getSchool().getName());
        }
        viewHolder.mDateTime.setText(DateUtils.forPattern(new DateTime(checkIn.getStart()), DateUtils.DATE_FORMAT_ABBREV));
        viewHolder.mTotalTime.setText(checkIn.getTotalTime());
        viewHolder.mComment.setText(checkIn.getComment());
    }

    private void setHeaderView(HeaderViewHolder viewHolder) {
        CheckInUtils.setCheckInSummary(mActivity, mUser, viewHolder.mHoursWeekly, viewHolder.mPercent,
                                        viewHolder.mHoursRequired, viewHolder.mActive, viewHolder.mProgressBar);
    }

    @Override
    public int getItemCount() { return mItems.size(); }

    @Override
    public int getItemViewType(int position) {
        return mItems.get(position).getType();
    }

    public void setCheckIns(User user) {
        mUser = user;
        setUpCheckIn();
        notifyDataSetChanged();
    }

    static class HeaderViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.user_hours_weekly) TextView mHoursWeekly;
        @Bind(R.id.user_hours_required) TextView mHoursRequired;
        @Bind(R.id.user_progress_bar) ProgressBar mProgressBar;
        @Bind(R.id.user_percent) TextView mPercent;
        @Bind(R.id.user_active_image) ImageView mActive;

        public HeaderViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }

    static class ListViewHolder extends RecyclerView.ViewHolder {
        @Bind(R.id.check_in_list_item_at) TextView mAt;
        @Bind(R.id.check_in_list_item_user) TextView mUserText;
        @Bind(R.id.check_in_list_item_date_time) TextView mDateTime;
        @Bind(R.id.check_in_list_item_school) TextView mSchoolText;
        @Bind(R.id.check_in_list_item_total) TextView mTotalTime;
        @Bind(R.id.check_in_list_item_comment) TextView mComment;

        public ListViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
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
