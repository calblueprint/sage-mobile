package blueprint.com.sage.checkIn;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/11/15.
 * Adapter for Check In lists
 */
public class CheckInListAdapter extends RecycleViewEmpty.Adapter<CheckInListAdapter.ViewHolder> {

    private CheckInListActivity mActivity;
    private int mLayoutId;
    private List<CheckIn> mCheckIns;

    public CheckInListAdapter(CheckInListActivity activity, int layoutId, List<CheckIn> checkIns) {
        super();
        mActivity = activity;
        mLayoutId = layoutId;
        mCheckIns = checkIns;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mActivity).inflate(mLayoutId, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, final int position) {
        if (getItemCount() == 0 || position < 0 || position >= getItemCount())
            return;

        final CheckIn checkIn = mCheckIns.get(position);

        viewHolder.mUser.setText(checkIn.getUser().getName());
        viewHolder.mSchool.setText(checkIn.getSchool().getName());
        viewHolder.mTotalTime.setText(checkIn.getTotalTime());

        String comment = checkIn.getComment() == null ? "No Comment" : checkIn.getComment();
        viewHolder.mComment.setText(comment);

        viewHolder.mVerify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mActivity.makeVerifyCheckInRequest(checkIn, position);
            }
        });

        viewHolder.mDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mActivity.makeDeleteCheckInRequest(checkIn, position);
            }
        });
    }

    @Override
    public int getItemCount() { return mCheckIns.size(); }

    public void setCheckIns(List<CheckIn> checkIns) {
        mCheckIns = checkIns;
        notifyDataSetChanged();
    }

    public void removeCheckIn(int position) {
        mCheckIns.remove(position);
        notifyItemRemoved(position);
    }

    public static class ViewHolder extends RecycleViewEmpty.ViewHolder {

        @Bind(R.id.check_in_list_item_user) TextView mUser;
        @Bind(R.id.check_in_list_item_school) TextView mSchool;
        @Bind(R.id.check_in_list_item_total) TextView mTotalTime;
        @Bind(R.id.check_in_list_item_comment) TextView mComment;
        @Bind(R.id.check_in_list_item_verify) ImageButton mVerify;
        @Bind(R.id.check_in_list_item_delete) ImageButton mDelete;

        public ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
