package blueprint.com.sage.shared.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.utility.view.ViewUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/14/15.
 */
public abstract class TabsFragment extends Fragment {

    @Bind(R.id.tab_view) public TabLayout mTabLayout;
    @Bind(R.id.view_pager) public ViewPager mViewPager;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_tabs, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        ViewUtils.setToolBarElevation(getActivity(), 0);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        ViewUtils.setToolBarElevation(getActivity(), 8);
    }

    public abstract void initializeViews();
}
