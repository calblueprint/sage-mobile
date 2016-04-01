package blueprint.com.sage.shared.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.filters.FilterController;
import butterknife.Bind;
import butterknife.OnClick;

/**
 * Created by charlesx on 4/1/16.
 */
public abstract class ListFilterFragment extends Fragment {

    public FilterController mFilterController;

    // Filter related ui
    @Bind(R.id.announcement_filter_container) public View mFilterView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mFilterController = new FilterController();
    }

    public abstract void initializeFilters();

    @OnClick(R.id.filter_confirm)
    public abstract void onFilterClick();

    @OnClick(R.id.filter_view)
    public void onFilterViewShow() {
        mFilterController.showFilter(getActivity(), mFilterView);
    }

    @OnClick(R.id.filter_cancel)
    public void onFilterViewHide() {
        mFilterController.hideFilter(getActivity(), mFilterView);
    }
}
