package blueprint.com.sage.shared.adapters.models;

import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.joda.time.DateTime;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.utility.view.DateUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 1/7/16.
 */
public abstract class AbstractSemesterListAdapter extends RecyclerView.Adapter<AbstractSemesterListAdapter.ViewHolder> {

    public FragmentActivity mActivity;
    public List<Semester> mSemesters;

    public AbstractSemesterListAdapter(FragmentActivity activity, List<Semester> semesters) {
        super();
        mActivity = activity;
        mSemesters = semesters;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int type) {
        View view = LayoutInflater.from(mActivity).inflate(R.layout.semester_list_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        if (getItemCount() == 0 || position >= getItemCount() || position < 0)
            return;

        final Semester semester = mSemesters.get(position);
        viewHolder.mSemesterTitle.setText(semester.toString());
        viewHolder.mSemesterDate.setText(DateUtils.getDateRange(new DateTime(semester.getStart()),
                                            new DateTime(semester.getFinish()), DateUtils.ABBREV_YEAR_FORMAT));
        viewHolder.mView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onItemClicked(view, semester);
            }
        });
    }

    public abstract void onItemClicked(View view, Semester semester);


    @Override
    public int getItemCount() { return mSemesters.size(); }

    public void setSemesters(List<Semester> semesters) {
        mSemesters = semesters;
        notifyDataSetChanged();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        @Bind(R.id.semester_list_item_date) TextView mSemesterDate;
        @Bind(R.id.semester_list_item_title) TextView mSemesterTitle;
        View mView;

        public ViewHolder(View v) {
            super(v);
            mView = v;
            ButterKnife.bind(this, v);
        }
    }
}
