package blueprint.com.sage.utility;

import android.util.Log;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by charlesx on 10/30/15.
 */
public class DateUtils {
    public static Date stringToDate(String time) {
        DateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.ENGLISH);
        Date date = null;

        try {
            date = format.parse(time);
        } catch (ParseException e) {
            Log.e("ParseException", e.toString());
        }

        return date;
    }

    public static String dateToString(Date date) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.ENGLISH);
        return dateFormat.format(date);
    }

    public static String dateDiff(Date date1, Date date2) {
        
    }
}
