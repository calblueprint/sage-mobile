package blueprint.com.sage.shared.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import blueprint.com.sage.shared.filters.FilterController;

/**
 * Created by charlesx on 4/1/16.
 */
public abstract class ListFilterFragment extends Fragment {

    public FilterController mFilterController;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mFilterController = new FilterController();
    }

    public abstract void initializeFilters();
    public abstract void onFilterClick();
    public abstract void onFilterViewShow();
    public abstract void onFilterViewHide();
}
