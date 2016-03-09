package blueprint.com.sage.shared.filters;

import android.content.Context;
import android.view.View;
import android.view.animation.Animation;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.utility.view.AnimationUtils;

/**
 * Created by charlesx on 3/6/16.
 */
public class FilterController {

    protected HashMap<String, String> mQueryParams;
    protected List<Filter> mFilters;

    public FilterController() {
        mQueryParams = new HashMap<>();
        mFilters = new ArrayList<>();
    }

    public void addFilters(Filter... filters) {
        mFilters.addAll(Arrays.asList(filters));
    }

    public void onFilterChecked(int id) {
        for (Filter filter : mFilters) {
            filter.setChecked(filter.getId() == id);
        }
    }

    public HashMap<String, String> getQueryParams(HashMap<String, String> queryParams) {
        mQueryParams.putAll(queryParams);
        return mQueryParams;
    }

    public void resetFilters() {
        mQueryParams = new HashMap<>();
    }

    public void showFilter(Context context, View view) {
        Animation animation = AnimationUtils.getBounceSlideDownAnimator(context);
        view.startAnimation(animation);
        view.setVisibility(View.VISIBLE);
    }

    public void hideFilter(Context context, View view) {
        Animation animation = AnimationUtils.getBounceSlideUpAnimator(context);
        view.startAnimation(animation);
        view.setVisibility(View.GONE);
    }
}
