package com.pawconnect.model;

import java.sql.Timestamp;

public class Pet {
    private int petId;
    private String petName;
    private int categoryId;
    private String categoryName;
    private String breed;
    private String age;
    private String gender;
    private String color;
    private double weight;
    private double price;
    private String description;
    private String healthStatus;
    private boolean vaccinationStatus;
    private String location;
    private String imageUrl;
    private String imageUrl2;
    private boolean isAvailable;
    private Timestamp createdAt;
    private double avgRating;
    private int reviewCount;
    // Care Guide fields
    private String careGuide;
    private String foodGuide;
    private String healthTips;
    private String doList;
    private String dontList;

    public Pet() {}

    // Getters and Setters
    public int getPetId() { return petId; }
    public void setPetId(int petId) { this.petId = petId; }

    public String getPetName() { return petName; }
    public void setPetName(String petName) { this.petName = petName; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }

    public String getAge() { return age; }
    public void setAge(String age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getHealthStatus() { return healthStatus; }
    public void setHealthStatus(String healthStatus) { this.healthStatus = healthStatus; }

    public boolean isVaccinationStatus() { return vaccinationStatus; }
    public void setVaccinationStatus(boolean vaccinationStatus) { this.vaccinationStatus = vaccinationStatus; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getImageUrl2() { return imageUrl2; }
    public void setImageUrl2(String imageUrl2) { this.imageUrl2 = imageUrl2; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public String getCareGuide() { return careGuide; }
    public void setCareGuide(String careGuide) { this.careGuide = careGuide; }

    public String getFoodGuide() { return foodGuide; }
    public void setFoodGuide(String foodGuide) { this.foodGuide = foodGuide; }

    public String getHealthTips() { return healthTips; }
    public void setHealthTips(String healthTips) { this.healthTips = healthTips; }

    public String getDoList() { return doList; }
    public void setDoList(String doList) { this.doList = doList; }

    public String getDontList() { return dontList; }
    public void setDontList(String dontList) { this.dontList = dontList; }
}
