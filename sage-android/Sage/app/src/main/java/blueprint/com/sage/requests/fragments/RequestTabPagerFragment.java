package blueprint.com.sage.requests.fragments;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.adapters.SimplePagerAdapter;
import blueprint.com.sage.shared.fragments.TabsFragment;

/**
 * Created by charlesx on 11/14/15.
 */
public class RequestTabPagerFragment extends TabsFragment {

    private SimplePagerAdapter mPagerAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) { super.onCreate(savedInstanceState); }

    public static RequestTabPagerFragment newInstance() { return new RequestTabPagerFragment();}

    public void initializeViews() {
        mPagerAdapter = new SimplePagerAdapter(getChildFragmentManager());

        mPagerAdapter.addFragment(VerifyCheckInListFragment.newInstance(), getString(R.string.requests_check_in));
        mPagerAdapter.addFragment(VerifyUsersListFragment.newInstance(), getString(R.string.requests_users));

        mViewPager.setAdapter(mPagerAdapter);
        mTabLayout.setupWithViewPager(mViewPager);

        getActivity().setTitle("Requests");
    }
}
