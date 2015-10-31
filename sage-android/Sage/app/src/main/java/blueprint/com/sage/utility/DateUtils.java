package blueprint.com.sage.utility;

import android.util.Log;

import org.joda.time.DateTime;
import org.joda.time.Period;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by charlesx on 10/30/15.
 * Date utilities.
 */
public class DateUtils {

    public static String DATE_FORMAT = "yyyy/MM/dd HH:mm a";
    public static String TIME_FORMAT = "HH:mm a";
    public static String DAY_FORMAT = "MMM dd, yyyy";

    public static Date stringToDate(String time) {
        DateFormat format = new SimpleDateFormat(DATE_FORMAT, Locale.ENGLISH);
        Date date = null;

        try {
            date = format.parse(time);
        } catch (ParseException e) {
            Log.e("ParseException", e.toString());
        }

        return date;
    }

    public static String dateToString(Date date) {
        DateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT, Locale.ENGLISH);
        return dateFormat.format(date);
    }

    public static String timeDiff(DateTime start, DateTime end) {
        Period period = new Period(start, end);

        int days = period.getDays();
        int hours = period.getHours() + 24 * days;
        int minutes = period.getMinutes();

        return String.format("%d hrs, %d min", hours, minutes);
    }

    public static String getFormattedDate(DateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(DAY_FORMAT);
        return formatter.print(dateTime);
    }

    public static String getFormattedTime(DateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(TIME_FORMAT);
        return formatter.print(dateTime);
    }

    public static String getFormattedTimeNow() {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(DateUtils.DATE_FORMAT);
        return formatter.print(DateTime.now());
    }
}
