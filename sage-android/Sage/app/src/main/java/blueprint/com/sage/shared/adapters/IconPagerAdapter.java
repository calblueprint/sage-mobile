package blueprint.com.sage.shared.adapters;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 12/23/15.
 */
public class IconPagerAdapter extends FragmentPagerAdapter {

    private List<Fragment> mFragments;
    private List<Integer> mDrawables;
    private List<View> mTabViews;
    private Context mContext;

    public IconPagerAdapter(FragmentManager fm, Context context) {
        super(fm);
        mFragments = new ArrayList<>();
        mDrawables = new ArrayList<>();
        mTabViews = new ArrayList<>();
        mContext = context;
    }

    @Override
    public Fragment getItem(int position) { return mFragments.get(position); }

    @Override
    public int getCount() { return mFragments.size(); }

    public View getTabView(int position) {
        return mTabViews.get(position);
    }

    public void addFragment(Fragment fragment, int drawableId) {
        mFragments.add(fragment);
        mDrawables.add(drawableId);

        View view = LayoutInflater.from(mContext).inflate(R.layout.tab_view, null);

        ImageView imageView = (ImageView) view.findViewById(R.id.tab_view_image);
        imageView.setImageResource(drawableId);

        mTabViews.add(view);
    }
}
