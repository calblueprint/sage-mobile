package blueprint.com.sage.requests.fragments;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.adapters.PagerAdapter;
import blueprint.com.sage.shared.fragments.TabsFragment;
import blueprint.com.sage.shared.interfaces.NavigationInterface;

/**
 * Created by charlesx on 11/14/15.
 */
public class RequestTabPagerFragment extends TabsFragment {

    private PagerAdapter mPagerAdapter;

    private NavigationInterface mNavigationInterface;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNavigationInterface = (NavigationInterface) getActivity();
    }

    public static RequestTabPagerFragment newInstance() { return new RequestTabPagerFragment();}

    public void initializeViews() {
        mPagerAdapter = new PagerAdapter(getChildFragmentManager());

        mPagerAdapter.addFragment(VerifyCheckInListFragment.newInstance(), getString(R.string.requests_check_in));
        mPagerAdapter.addFragment(VerifyUsersListFragment.newInstance(), getString(R.string.requests_users));

        mViewPager.setAdapter(mPagerAdapter);
        mTabLayout.setupWithViewPager(mViewPager);

        mNavigationInterface.toggleDrawerUse(true);
        getActivity().setTitle("Requests");
    }
}
