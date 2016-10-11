package blueprint.com.sage.admin.browse.adapters;

import android.app.Activity;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;

import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.location.places.AutocompletePrediction;
import com.google.android.gms.location.places.AutocompletePredictionBuffer;
import com.google.android.gms.location.places.Places;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.view.MapUtils;

/**
 * Created by charlesx on 11/16/15.
 */
public class PlacePredictionAdapter extends ArrayAdapter<AutocompletePrediction> implements Filterable {

    private Activity mActivity;
    private int mLayoutId;
    private List<AutocompletePrediction> mPredictions;
    private BaseInterface mBaseInterface;

    public PlacePredictionAdapter(Activity activity, int layoutId, List<AutocompletePrediction> predictions) {
        super(activity, layoutId, predictions);
        mActivity = activity;
        mLayoutId = layoutId;
        mPredictions = predictions;
        mBaseInterface = (BaseInterface) activity;
    }

    @Override
    public AutocompletePrediction getItem(int position) { return mPredictions.get(position); }

    @Override
    public int getCount() { return mPredictions.size(); }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = convertView;
        ViewHolder placeViewHolder;
        if (view == null) {
            view = LayoutInflater.from(mActivity).inflate(mLayoutId, parent, false);
            placeViewHolder = new ViewHolder();

            placeViewHolder.mTopLabel = (TextView) view.findViewById(R.id.place_prediction_top);
            placeViewHolder.mBottomLabel = (TextView) view.findViewById(R.id.place_prediction_bottom);

            view.setTag(placeViewHolder);
        } else {
            placeViewHolder = (ViewHolder) view.getTag();
        }

        AutocompletePrediction prediction = getItem(position);
        String[] description = prediction.getDescription().split(",");
        String street = description[0].trim();

        String city = null;
        if (description.length > 1) city = description[1].trim();

        String state = null;
        if (description.length > 2) state = description[2].trim();

        placeViewHolder.mTopLabel.setText(street);

        if (city != null && state != null) {
            String bottomLabel = String.format("%s, %s", city, state);
            placeViewHolder.mBottomLabel.setText(bottomLabel);
        }

        return view;
    }

    @Override
    public Filter getFilter() {
        Filter filter = new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                FilterResults filterResults = new FilterResults();
                if (constraint != null) {
                    getPredictions(constraint.toString());
                    filterResults.values = mPredictions;
                    filterResults.count = mPredictions.size();
                }
                return filterResults;
            }

            @Override
            protected void publishResults(CharSequence constraint, FilterResults results) {
                if (results != null && results.count > 0) {
                    notifyDataSetChanged();
                } else {
                    notifyDataSetInvalidated();
                }
            }};
        return filter;
    }

    private void getPredictions(String address) {
        PendingResult<AutocompletePredictionBuffer> result =
                Places.GeoDataApi.getAutocompletePredictions(mBaseInterface.getGoogleApiClient(), address,
                        MapUtils.createBounds(MapUtils.SW_LAT, MapUtils.SW_LNG, MapUtils.NE_LAT, MapUtils.NE_LNG), null);

        if (result == null)
            return;

        result.setResultCallback(new ResultCallback<AutocompletePredictionBuffer>() {
            @Override
            public void onResult(@NonNull AutocompletePredictionBuffer result) {
                List<AutocompletePrediction> predictions = new ArrayList<AutocompletePrediction>();
                for (AutocompletePrediction prediction : result) {
                    predictions.add(prediction.freeze());
                }
                result.release();
                setPredictions(predictions);
            }
        });
    }

    public void setPredictions(List<AutocompletePrediction> predictions) {
        mPredictions = predictions;
        notifyDataSetChanged();
    }

    static class ViewHolder  {
        TextView mTopLabel;
        TextView mBottomLabel;
    }

}
