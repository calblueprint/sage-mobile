package blueprint.com.sage.schools.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

import blueprint.com.sage.models.School;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
 */
public class SchoolsAdapter extends RecyclerView.Adapter<SchoolsAdapter.ViewHolder> {

    private Activity mActivity;
    private int mLayoutId;
    private List<School> mSchools;

    public SchoolsAdapter(Activity activity, int layoutId, List<School> schools) {
        mActivity = activity;
        mLayoutId = layoutId;
        mSchools = schools;
    }

    @Override
    public SchoolsAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mActivity).inflate(mLayoutId, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        if (getItemCount() <= 0 && position < 0 && position >= mSchools.size())
            return;


    }

    @Override
    public int getItemCount() { return mSchools.size(); }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public ViewHolder(View view) {
            super(view);

            ButterKnife.bind(this, view);
        }
    }
}
