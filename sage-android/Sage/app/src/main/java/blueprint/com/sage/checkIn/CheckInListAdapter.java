package blueprint.com.sage.checkIn;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/11/15.
 * Adapter for Check In lists
 */
public class CheckInListAdapter extends RecycleViewEmpty.Adapter<CheckInListAdapter.ViewHolder> {

    private Activity mActivity;
    private int mLayoutId;
    private List<CheckIn> mCheckIns;

    public CheckInListAdapter(Activity activity, int layoutId, List<CheckIn> checkIns) {
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
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        if (getItemCount() > 0 && position >= 0 && position < getItemCount())
            return;
    }

    @Override
    public int getItemCount() { return mCheckIns.size(); }

    public static class ViewHolder extends RecycleViewEmpty.ViewHolder {
        public ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
