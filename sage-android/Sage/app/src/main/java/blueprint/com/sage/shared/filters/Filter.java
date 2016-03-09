package blueprint.com.sage.shared.filters;

import android.widget.RadioButton;

/**
 * Created by charlesx on 3/8/16.
 */
public abstract class Filter {

    private RadioButton mRadioButton;

    public Filter(RadioButton radioButton) {
        mRadioButton = radioButton;
    }

    public int getId() {
        return mRadioButton.getId();
    }

    public boolean isChecked() {
        return mRadioButton.isChecked();
    }

    public void setChecked(boolean checked) {
        mRadioButton.setChecked(checked);
    }

    public abstract String getFilterKey();
    public abstract String getFilterValue();
}
