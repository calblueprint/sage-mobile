package blueprint.com.sage.schools.adapters;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.google.android.gms.location.places.AutocompletePrediction;

import java.util.List;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 11/16/15.
 */
public class PlacePredictionAdapter extends ArrayAdapter<AutocompletePrediction> {

    private Activity mActivity;
    private int mLayoutId;
    private List<AutocompletePrediction> mPredictions;

    public PlacePredictionAdapter(Activity activity, int layoutId, List<AutocompletePrediction> predictions) {
        super(activity, layoutId, predictions);
        mActivity = activity;
        mLayoutId = layoutId;
        mPredictions = predictions;
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

    public void setPredictions(List<AutocompletePrediction> predictions) {
        mPredictions = predictions;
        notifyDataSetChanged();
    }

    static class ViewHolder  {
        TextView mTopLabel;
        TextView mBottomLabel;
    }

}
