package blueprint.com.sage.browse.adapters;

import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.fragments.SchoolFragment;
import blueprint.com.sage.models.School;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
 * Adapter for schools
 */
public class SchoolsListAdapter extends RecyclerView.Adapter<SchoolsListAdapter.ViewHolder> {

    private FragmentActivity mActivity;
    private int mLayoutId;
    private List<School> mSchools;

    public SchoolsListAdapter(FragmentActivity activity, int layoutId, List<School> schools) {
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
    public void onBindViewHolder(ViewHolder holder, final int position) {
        if (getItemCount() <= 0 && position < 0 && position >= mSchools.size())
            return;

        final School school = mSchools.get(position);

        holder.mSchoolTitle.setText(school.getName());
        holder.mView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                FragUtils.replaceBackStack(R.id.container, SchoolFragment.newInstance(school, position), mActivity);
            }
        });
    }

    @Override
    public int getItemCount() { return mSchools.size(); }

    public void setSchools(List<School> schools) {
        mSchools = schools;
        notifyDataSetChanged();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.schools_list_item_title) TextView mSchoolTitle;

        View mView;

        public ViewHolder(View view) {
            super(view);
            mView = view;
            ButterKnife.bind(this, view);
        }
    }
}
