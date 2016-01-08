package blueprint.com.sage.semester.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.main.fragments.UserFragment;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 1/7/16.
 */
public class SemesterListAdapter extends RecyclerView.Adapter<SemesterListAdapter.ViewHolder> {

    private Context mContext;
    private List<Semester> mSemesters;

    public SemesterListAdapter(Context context, List<Semester> semesters) {
        super();
        mContext = context;
        mSemesters = semesters;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int type) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.semester_list_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        if (getItemCount() == 0 || position >= getItemCount() || position < 0)
            return;

        Semester semester = mSemesters.get(position);
        viewHolder.mSemesterTitle.setText(semester.toString());

        viewHolder.mView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                FragUtils.replaceBackStack(R.id.container, UserFragment.newInstance(user), mActivity);
            }
        });
    }

    @Override
    public int getItemCount() { return mSemesters.size(); }

    public static class ViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.semester_list_item_title) TextView mSemesterTitle;
        View mView;

        public ViewHolder(View v) {
            super(v);
            mView = v;
            ButterKnife.bind(this, v);
        }
    }
}
