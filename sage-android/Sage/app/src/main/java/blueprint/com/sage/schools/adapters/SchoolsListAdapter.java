package blueprint.com.sage.schools.adapters;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
 * Adapter for schools
 */
public class SchoolsListAdapter extends RecycleViewEmpty.Adapter<SchoolsListAdapter.ViewHolder> {

    private Activity mActivity;
    private int mLayoutId;
    private List<School> mSchools;

    public SchoolsListAdapter(Activity activity, int layoutId, List<School> schools) {
        super();
        mActivity = activity;
        mLayoutId = layoutId;
        mSchools = schools;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mActivity).inflate(mLayoutId, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        if (getItemCount() <= 0 && position < 0 && position >= mSchools.size())
            return;

        School school = mSchools.get(position);

        holder.mSchoolTitle.setText(school.getName());
    }

    @Override
    public int getItemCount() { return mSchools.size(); }

    public void setSchools(List<School> schools) {
        mSchools = schools;
        notifyDataSetChanged();
    }

    public static class ViewHolder extends RecycleViewEmpty.ViewHolder {

        @Bind(R.id.schools_list_item_title) TextView mSchoolTitle;

        public ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
