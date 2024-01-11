// JDBC: Online-Supermarkt

// Downloaden: in eine Datei mit Namen Supermarkt.java!
// Anpassen: Name der Datenbank und Benutzer!
// Uebersetzen: javac Supermarkt.java
// vor der Benutzung: Datenbank anlegen
// Usage: java Supermarkt
// danach: alleWaren oder Bestellungen oder Bestellen oder # (fuer Beenden)
// momentan notwendiger Treiber: postgresql-9.1-903-jdbc4.jar

import java.io.*;
import java.sql.*;
import java.util.*;

public class Supermarkt {
	static private Connection con;
    static Scanner sc = new Scanner(System.in);

    public Supermarkt() throws ClassNotFoundException, FileNotFoundException,
                                    IOException, SQLException {
    }
 
    public void alleWaren () throws Exception {
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT bezeichnung, preis, vorrat, kname FROM ware, kategorie");
 
        System.out.println(String.format("%s %12s %11s %10s", "Bezeichnung", "Preis", "Vorrat", "Kategorie"));
       	while (rs.next()) {
       	    System.out.println(String.format("%s %8.2f %7d %20s", 
       	                rs.getString("bezeichnung"),
       	                rs.getFloat("preis"),
       	                rs.getInt("vorrat"),
       	                rs.getString("kname")
       	                ));
       	}
        stmt.close();
        rs.close();
    }
 	   
    public void alleBestellungen() throws Exception {
		String kunde;
 	   	PreparedStatement pstmt = con.prepareStatement("SELECT bestid, datum, status, kname FROM bestellung JOIN Kunde ON kundid = kundeid WHERE kname = ?");
		
		while(true){
			System.out.println("Kundenname eingeben: ");
			kunde = sc.nextLine();

			if(kunde.isEmpty() || kunde.equals("#")) {
				return;
			}

			pstmt.setString(1, kunde);
			ResultSet rs = pstmt.executeQuery();

			try {
                System.out.println(String.format("%s %6s %12s %5s", "Best. ID", "Datum", "Status", "Name"));
                    while(rs.next()) {
                        System.out.println(String.format("%d %17s %3s %20s",
                                    rs.getInt("bestid"),
                                    rs.getString("datum"),
                                    rs.getString("status"),
                                    rs.getString("kname")
                                    ));
                    }
            }
            catch (Exception e) {
                System.out.println("Keine Bestellungen gefunden!");
            }
		}
	}
 	   
    public void bestellen() throws Exception {
 	   	Statement stmt = con.createStatement();
		int kundeID;
		String kunde, ware;

        PreparedStatement statementBestellung = con.prepareStatement("INSERT INTO bestellung(bestID, datum, status, kundID) VALUES (nextval('bestellid'), Current_Date, 0, ?)");
		PreparedStatement statementEnthaelt = con.prepareStatement("INSERT INTO enthaelt(bestID, warenID, anzahl) VALUES (currval('bestellid'), ?, ?)");
		List<Integer> anzahl = new ArrayList<Integer>();
        List<Integer> warenID = new ArrayList<Integer>();
		
		System.out.println("Kundenname eingeben: ");
        kunde = sc.nextLine();

		if(kunde.isEmpty() || kunde.equals("#")) {
			return;
		}

		ResultSet rs = stmt.executeQuery(String.format("SELECT kundeid FROM kunde WHERE kname = \'%s\'", kunde));

		try {
			rs.next();
			kundeID = rs.getInt("kundeid");
		} catch (Exception e) {
			System.out.println("Kunde wurde nicht gefunden!");
			rs.close();
			return;
		}

		while (true) {
            System.out.println("Warenname eingeben: ");
            ware = sc.nextLine();

            if (ware.isEmpty() || ware.equals("#")) {
                break;
        	}

			rs = stmt.executeQuery(String.format("SELECT warenid FROM ware WHERE bezeichnung = \'%s\'", ware));

			try {
				rs.next();
				warenID.add(rs.getInt("warenID"));
			} catch (Exception e) {
				System.out.println("Ware wurde nicht gefunden!");
				rs.close();
				return;
			}

			System.out.println("Anzahl eingeben: ");
			anzahl.add(sc.nextInt());

			if(anzahl.get(anzahl.size() - 1) <= 0) {
				System.out.println("Anzahl muss positiv sein!");
				return;
			}

			statementBestellung.setInt(1, kundeID);
			statementBestellung.executeUpdate();

			for (int k = 0; k < warenID.size(); k++) {
				statementEnthaelt.setInt(1, warenID.get(k));
				statementEnthaelt.setInt(2, anzahl.get(k));
				statementEnthaelt.executeUpdate();
			}

			sc.nextLine();
    	}

		stmt.close();
        statementBestellung.close();
		statementEnthaelt.close();
	}
    
    public static void main (String args[]) throws IOException {
		
 		if (args.length != 0) {
 			System.out.println ("Usage: java supermarkt");
 			System. exit(1);
 		}

 		String driverClass = "org.postgresql.Driver";

 		try {
 			Class.forName (driverClass);
 		} catch (ClassNotFoundException exc) {
 			System.out.println ("ClassNotFoundException: " + exc.getMessage() );
 		}

    	try {
			// 193.175.36.101 ist die vm3-1-Maschine 
			Class.forName ("org.postgresql.Driver");
			// Folgendes Statement: Name der Datenbank anpassen!
			String db_url = "jdbc:postgresql://127.0.0.1/postgres";
			// Folgendes Statement: Name des Benutzers anpassen!
			con = DriverManager.getConnection (db_url, "postgres", "");
			Supermarkt sup = new Supermarkt();
			String aufgabe = null;
			BufferedReader userin = new BufferedReader (new InputStreamReader (System.in));
			System.out.println("\nGeben Sie ein: Waren oder Bestellungen oder Bestellen oder #!\n");

			while ( ! (aufgabe =userin.readLine()).startsWith("#")) {
				if (aufgabe.equals ("Waren")) sup.alleWaren();
				else if (aufgabe.equals("Bestellungen")) sup.alleBestellungen();
				else if (aufgabe.equals("Bestellen")) sup.bestellen();
				System.out.println
					("\nGeben Sie ein: Waren oder Bestellungen oder Bestellen oder #!\n");
			}

			con.close();
    	} catch (Exception exc) {
    	    System.err.println ("Exception in Main. " + exc.getMessage());
 		 	exc.printStackTrace();
    	}
    }
}


