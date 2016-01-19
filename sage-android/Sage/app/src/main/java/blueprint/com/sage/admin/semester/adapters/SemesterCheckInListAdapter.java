package blueprint.com.sage.admin.semester.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;

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

    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(mActivity);
        return new ViewHolder(inflater.inflate(R.layout.check_in_list_item, parent, false));
    }

    public void onBindViewHolder(ViewHolder viewHolder, int position) {

    }

    public int getItemCount() { return mCheckIns.size(); }

    static class ViewHolder extends RecyclerView.ViewHolder {



        public ViewHolder(View v) {
            super(v);
        }
    }
}
