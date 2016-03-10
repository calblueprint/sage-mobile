package blueprint.com.sage.admin.semester.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.joda.time.DateTime;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.utility.view.DateUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 1/19/16.
 */
public class SemesterCheckInListAdapter extends RecyclerView.Adapter<SemesterCheckInListAdapter.ViewHolder> {

    private Activity mActivity;
    private List<CheckIn> mCheckIns;

    public SemesterCheckInListAdapter(Activity activity, List<CheckIn> checkIns) {
        super();
        mActivity = activity;
        mCheckIns = checkIns;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(mActivity);
        return new ViewHolder(inflater.inflate(R.layout.check_in_list_item, parent, false));
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        if (getItemCount() == 0 || position < 0 || position >= getItemCount())
            return;

        CheckIn checkIn = mCheckIns.get(position);

        if (checkIn.getUser() == null) {
            viewHolder.mAt.setVisibility(View.GONE);
            viewHolder.mUserText.setVisibility(View.GONE);
        } else {
            viewHolder.mUserText.setText(checkIn.getUser().getName());
        }
        if (checkIn.getSchool() == null) {
            viewHolder.mSchoolText.setVisibility(View.GONE);
        } else {
            viewHolder.mSchoolText.setText(checkIn.getSchool().getName());
        }

        viewHolder.mDateTime.setText(DateUtils.forPattern(new DateTime(checkIn.getStart()), DateUtils.DATE_FORMAT_ABBREV));
        viewHolder.mTotalTime.setText(checkIn.getTotalTime());
        viewHolder.mComment.setText(checkIn.getComment());
    }

    @Override
    public int getItemCount() { return mCheckIns.size(); }

    public void setCheckIns(List<CheckIn> checkIns) {
        mCheckIns = checkIns;
        notifyDataSetChanged();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.check_in_list_item_at) TextView mAt;
        @Bind(R.id.check_in_list_item_user) TextView mUserText;
        @Bind(R.id.check_in_list_item_date_time) TextView mDateTime;
        @Bind(R.id.check_in_list_item_school) TextView mSchoolText;
        @Bind(R.id.check_in_list_item_total) TextView mTotalTime;
        @Bind(R.id.check_in_list_item_comment) TextView mComment;

        public ViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }
}
