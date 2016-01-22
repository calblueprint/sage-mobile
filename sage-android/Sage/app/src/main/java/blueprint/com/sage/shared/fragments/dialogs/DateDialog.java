package blueprint.com.sage.shared.fragments.dialogs;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.widget.DatePicker;
import android.widget.TextView;

import java.util.Calendar;

import blueprint.com.sage.shared.interfaces.DateInterface;
import lombok.Setter;

/**
 * Created by charlesx on 1/6/16.
 */
public class DateDialog extends DialogFragment implements DatePickerDialog.OnDateSetListener {

    @Setter
    private TextView textView;

    @Setter
    private DateInterface dateInterface;

    public static DateDialog newInstance(TextView textView, DateInterface dateInterface) {
        DateDialog picker = new DateDialog();
        picker.setTextView(textView);
        picker.setDateInterface(dateInterface);
        return picker;
    }

    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the current date as the default date in the picker
        final Calendar c = Calendar.getInstance();
        int year = c.get(Calendar.YEAR);
        int month = c.get(Calendar.MONTH);
        int day = c.get(Calendar.DAY_OF_MONTH);

        // Create a new instance of DatePickerDialog and return it
        return new DatePickerDialog(getActivity(), this, year, month, day);
    }

    public void onDateSet(DatePicker view, int year, int month, int day) {
        dateInterface.setDate(textView, year, month + 1, day);
    }
}
