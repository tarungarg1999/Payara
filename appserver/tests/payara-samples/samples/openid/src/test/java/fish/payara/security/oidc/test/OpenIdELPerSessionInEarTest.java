/*
 *  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 * 
 *  Copyright (c) [2021] Payara Foundation and/or its affiliates. All rights reserved.
 * 
 *  The contents of this file are subject to the terms of either the GNU
 *  General Public License Version 2 only ("GPL") or the Common Development
 *  and Distribution License("CDDL") (collectively, the "License").  You
 *  may not use this file except in compliance with the License.  You can
 *  obtain a copy of the License at
 *  https://github.com/payara/Payara/blob/master/LICENSE.txt
 *  See the License for the specific
 *  language governing permissions and limitations under the License.
 * 
 *  When distributing the software, include this License Header Notice in each
 *  file and include the License file at glassfish/legal/LICENSE.txt.
 * 
 *  GPL Classpath Exception:
 *  The Payara Foundation designates this particular file as subject to the "Classpath"
 *  exception as provided by the Payara Foundation in the GPL Version 2 section of the License
 *  file that accompanied this code.
 * 
 *  Modifications:
 *  If applicable, add the following below the License Header, with the fields
 *  enclosed by brackets [] replaced by your own identifying information:
 *  "Portions Copyright [year] [name of copyright owner]"
 * 
 *  Contributor(s):
 *  If you wish your version of this file to be governed by only the CDDL or
 *  only the GPL Version 2, indicate your decision by adding "[Contributor]
 *  elects to include this software in this distribution under the [CDDL or GPL
 *  Version 2] license."  If you don't indicate a single choice of license, a
 *  recipient has the option to distribute your version of this file under
 *  either the CDDL, the GPL Version 2 or to extend the choice of license to
 *  its licensees as provided above.  However, if you add GPL Version 2 code
 *  and therefore, elected the GPL Version 2 license, then the option applies
 *  only if the new code is made subject to such option by the copyright
 *  holder.
 */
package fish.payara.security.oidc.test;

import com.gargoylesoftware.htmlunit.WebClient;
import fish.payara.samples.NotMicroCompatible;
import fish.payara.samples.PayaraArquillianTestRunner;
import fish.payara.samples.SincePayara;
import fish.payara.security.oidc.client.ear.SomeEJB;
import fish.payara.security.oidc.client.elpersessiontests.SecuredPageEL;
import java.io.IOException;
import java.net.URL;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.container.test.api.OperateOnDeployment;
import org.jboss.arquillian.container.test.api.RunAsClient;
import org.jboss.arquillian.test.api.ArquillianResource;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.spec.EnterpriseArchive;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.jboss.shrinkwrap.api.spec.WebArchive;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

/**
 *
 * @author Ondro Mihalyi
 */
@NotMicroCompatible
@RunWith(PayaraArquillianTestRunner.class)
@SincePayara("5.29.0")
public class OpenIdELPerSessionInEarTest {

    private static final String TEST_RESOURCES_PREFIX = "elpersessiontests";

    @OperateOnDeployment("openid-client")
    @ArquillianResource
    private URL base;

    private WebClient webClient;

    @Before
    public void init() {
        webClient = new WebClient();
    }

    @Deployment(name = "openid-server")
    public static WebArchive createServerDeployment() {
        return OpenIdTestUtil.createServerDeployment();
    }

    @Deployment(name = "openid-client")
    public static EnterpriseArchive createClientDeployment() {
        WebArchive war = OpenIdTestUtil.createClientDeployment()
                .addPackage(SecuredPageEL.class.getPackage())
                .addAsWebInfResource(TEST_RESOURCES_PREFIX + "/META-INF/microprofile-config.properties", "classes/META-INF/microprofile-config.properties");
        JavaArchive ejbJar = ShrinkWrap.create(JavaArchive.class, "openid-client-dummy-ejb.jar")
                .addClasses(SomeEJB.class);
        JavaArchive configJar = ShrinkWrap.create(JavaArchive.class, "openid-client-config.jar")
                .addAsResource(TEST_RESOURCES_PREFIX + "/META-INF/microprofile-config.properties", "META-INF/microprofile-config.properties");
        EnterpriseArchive ear = ShrinkWrap.create(EnterpriseArchive.class, "openid-client.ear")
                .addAsLibraries(configJar) // required because Payara doesn't find microprofile-config.properties in the WAR. When this is fixed, configJar can be removed
                .addAsModules(war, ejbJar)
                .addAsResource("ear/META-INF/application.xml", "application.xml");
        return ear;
    }

    @Test
    @RunAsClient
    public void testOpenIdConnect() throws IOException {
        OpenIdTestUtil.testOpenIdConnect(webClient, base);
    }

    /**
     * Tests that it's possible to authenticate as 2 different tenants in 2
     * sessions. Tenant specifies a provider, each session should use a
     * different OIDC provider and authenticate as a different user.
     * Tenant-specific configuration is in microprofile-config.properties.
     */
    @Test
    @RunAsClient
    public void testOpenIdConnect2Tenants() throws IOException {
        WebClient clientForSecondTenant = new WebClient();
        OpenIdTestUtil.testOpenIdConnect2Tenants(base, webClient, clientForSecondTenant);
    }

}
