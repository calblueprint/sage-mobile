package blueprint.com.sage.requests.adapters;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.requests.RequestsActivity;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/11/15.
 * Adapter for Check In lists
 */
public class CheckInListAdapter extends RecyclerView.Adapter<CheckInListAdapter.ViewHolder> {

    private RequestsActivity mActivity;
    private int mLayoutId;
    private List<CheckIn> mCheckIns;

    public CheckInListAdapter(RequestsActivity activity, int layoutId, List<CheckIn> checkIns) {
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
                Requests.CheckIns.with(mActivity).makeVerifyRequest(checkIn, position);
            }
        });

        viewHolder.mDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Requests.CheckIns.with(mActivity).makeDeleteRequest(checkIn, position);
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

    public static class ViewHolder extends RecyclerView.ViewHolder {

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
