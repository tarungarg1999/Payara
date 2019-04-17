/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sun.jdo.api.persistence.enhancer;
import com.sun.enterprise.util.JDK;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.net.URL;
import java.security.AccessControlContext;
import java.security.cert.Certificate;
import java.util.jar.Manifest;

/**
 *
 * @author jGauravGupta
 */
public class URLClassPath {

    private static final String URL_CLASSPATH_CLASS_NAME = JDK.getMajor() > 8 ? "jdk.internal.loader.URLClassPath" : "sun.misc.URLClassPath";
    private static Constructor constructor;
    private static final String GET_RESOURCE_METHOD_NAME = "getResource";
    private static Method getResource;

    private Object instance;

    public URLClassPath(URL[] urls, AccessControlContext acc) {
        try {
            if (constructor == null) {
                Class clazz = Class.forName(URL_CLASSPATH_CLASS_NAME);
                constructor = clazz.getConstructor(URL[].class, AccessControlContext.class);
            }
            instance = constructor.newInstance(urls, acc);
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }

    }

     Resource getResource(String name, boolean check) {
        if (getResource == null) {
            getResource = getMethod(instance, GET_RESOURCE_METHOD_NAME, String.class, boolean.class);
        }
        return new Resource(invoke(instance, getResource, name, check));
    }

    static Method getMethod(Object instance, String name, Class<?>... parameterTypes) {
        try {
            return instance.getClass().getMethod(name, parameterTypes);
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    static Object invoke(Object instance, Method method, Object... args) {
        try {
            return method.invoke(instance, args);
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

}

class Resource {

    private final Object instance;
    private static final String GET_CODE_SOURCE_URL_METHOD_NAME = "getCodeSourceURL";
    private static Method getCodeSourceURL;
    private static final String GET_MANIFEST_METHOD_NAME = "getManifest";
    private static Method getManifest;
    private static final String GET_BYTES_METHOD_NAME = "getBytes";
    private static Method getBytes;
    private static final String GET_CERTIFICATES_METHOD_NAME = "getCertificates";
    private static Method getCertificates;

    public Resource(Object instance) {
        this.instance = instance;
    }

    public URL getCodeSourceURL() {
        if (getCodeSourceURL == null) {
            getCodeSourceURL = URLClassPath.getMethod(instance, GET_CODE_SOURCE_URL_METHOD_NAME);
        }
        return (URL) URLClassPath.invoke(instance, getCodeSourceURL);
    }

    public Manifest getManifest() throws IOException {
        if (getManifest == null) {
            getManifest = URLClassPath.getMethod(instance, GET_MANIFEST_METHOD_NAME);
        }
        return (Manifest) URLClassPath.invoke(instance, getManifest);
    }

    public byte[] getBytes() throws IOException {
        if (getBytes == null) {
            getBytes = URLClassPath.getMethod(instance, GET_BYTES_METHOD_NAME);
        }
        return (byte[]) URLClassPath.invoke(instance, getBytes);
    }

    public Certificate[] getCertificates() {
        if (getCertificates == null) {
            getCertificates = URLClassPath.getMethod(instance, GET_CERTIFICATES_METHOD_NAME);
        }
        return (Certificate[]) URLClassPath.invoke(instance, getCertificates);
    }
}
