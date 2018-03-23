package commands;

import com.google.gson.JsonObject;
import database.DBBroker;

import org.json.JSONException;
import org.json.JSONObject;


public class UpdateUserStatus extends BaseCommand {
    DBBroker dbBroker;
    String userNumber;
    String user_status_new;

    /**
     * Constructor
     *
     * @param dbBroker
     * @param request
     */

    public UpdateUserStatus(DBBroker dbBroker, JsonObject request) {
        this.dbBroker = dbBroker;
        this.userNumber = request.get("userNumber").getAsString();
        this.user_status_new = request.get("user_status_new").getAsString();
    }


    /**
     * Execute the update command
     * @return JSONObject query result
     */
    public JSONObject execute() {
        String query =  "UPDATE users SET user_status = "+"'"+user_status_new+"'"+"WHERE mobile_number LIKE" +"'" +userNumber+"'";
        try {
            return this.dbBroker.executeSQLQuery(query);
        }
        catch (JSONException e) {
            e.printStackTrace();
        }

        return null;
    }
}

