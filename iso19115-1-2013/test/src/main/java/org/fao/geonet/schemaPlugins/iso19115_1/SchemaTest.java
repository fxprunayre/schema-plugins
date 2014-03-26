package org.fao.geonet.schemaPlugins.iso19115_1;

import org.fao.geonet.schemaPlugins.AbstractSchemaTest;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.Test;

/**
 * Created by francois on 3/24/14.
 */
public class SchemaTest extends AbstractSchemaTest {
    public SchemaTest() {
        setSchemaIdentifier("iso19115-1-2013");
    }

    @Test
    public void testSetAndExtractUUID() throws Exception {
        String metadatauuid = "123456";
        Element metadata = Xml.loadFile(getSchemaPath() + getSchemaIdentifier() +
                "/test/resources/metadata.xml");
        Element root = new Element("root");
        Element env = new Element("env");
        Element uuid = new Element("uuid").setText(metadatauuid);
        env.addContent(uuid);
        root.addContent(env);
        root.addContent(metadata);

        Element results = transform(root, "/set-uuid.xsl");

        assertEquals("Root node is the metadata record root MD_Metadata.", results.getName(), "MD_Metadata");
        assertNotSame("Root node is not the root node from the input document.", results.getName(), "root");
        assertNull("Env node is removed from metadata record.", results.getChild("env"));
        assertEquals("Metadata UUID is updated.",
                results.getChild("metadataIdentifier", Namespaces.MDS)
                        .getChild("MD_Identifier", Namespaces.MCC)
                        .getChild("code", Namespaces.MCC)
                        .getChildText("CharacterString", Namespaces.GCO)
                , metadatauuid);

        Element results2 = transform(results, "/extract-uuid.xsl");
        assertEquals("Root is uuid..", results2.getName(), "uuid");
        assertEquals("Metadata UUID is extracted properly..", results2.getText(), metadatauuid);
    }

    @Test
    public void testExtractGML() throws Exception {
        Element results = transform("/test/resources/metadata.xml", "/extract-gml.xsl");

        assertNotNull ("Extracted geometry is not null.", results);
        assertEquals("Extracted geometry is a gml:GeometryCollection.",
                results.getName(), "GeometryCollection");
    }
}
