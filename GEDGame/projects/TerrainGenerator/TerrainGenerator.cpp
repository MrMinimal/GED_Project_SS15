// TerrainGenerator.cpp : Definiert den Einstiegspunkt f�r die Konsolenanwendung.
//
#include "stdafx.h"
#include <cstdlib>
#include <string>
#include <random>
#include <iostream>
#include <ctime>
#include <SimpleImage.h>
#include <TextureGenerator.h>
#include "DiamondSquare.h"

#include "Vec3f.h"

#define IDX(x, y, w)((x) + (y) * (w))


int _tmain(int argc, _TCHAR* argv[])
{
	std::cout << "TESTING: " << std::endl;

	Vec3f testVec1(1,-5,2);
	Vec3f testVec2(2,0,3);
	Vec3f sol = testVec1.cross(testVec2);
	std::cout << sol.printVec();

	system("pause");

	int resolution;
	_TCHAR* pathHeightfield = L"";
	_TCHAR* pathColor = L"";
	_TCHAR* pathNormal = L"";

	// Invalid parameters
	if (argc != 9)
	{
		std::cerr << "Usage: -r <resolution> -o_height <output heightfield filename> -o_color <output color filename> -o_normal <output normal filename>" << std::endl;
		system("pause");
		return 1;
	}

	// Read parameters
	for (int i = 0; i < argc; i++)
	{
		std::wstring arg(argv[i]);
		if (arg == L"-r")
		{
			resolution = _tstoi(argv[i + 1]);
			i++;
			if (resolution <= 0) // Invalid resolution
			{
				std::cerr << "Usage: -r <resolution> -o_height <output heightfield filename> -o_color <output color filename> -o_normal <output normal filename>" << std::endl;
				std::cerr << "resolution must be > 0" << std::endl;
				system("pause");
				return 1;
			}
		}
		else if (arg == L"-o_height")
		{
			pathHeightfield = argv[i + 1];
			i++;
		}
		else if (arg == L"-o_color")
		{
			pathColor = argv[i + 1];
			i++;
		}
		else if (arg == L"-o_normal")
		{
			pathNormal = argv[i + 1];
			i++;
		}
	}

	// Play around with these values ;)
	float roughness = 0.6f; // "spikyness", the closer to zero, the flatter
	int smoothCount = 25;	// smoothCount times smoothed
	int smoothRange = 2;	// "Smoothing Radius" 

	GEDUtils::SimpleImage heightImage(resolution, resolution);

	DiamondSquare ds(resolution, roughness, smoothCount, smoothRange);
	std::vector<float> pic = ds.doDiamondSquare();

	std::cout << "[Image] Writing image..." << std::endl;
	for (int x = 0; x < resolution; x++)
	{
		for (int y = 0; y < resolution; y++)
		{
			heightImage.setPixel(x, y, pic[IDX(x, y, resolution + 1)]);
		}
	}

	std::cout << "[Image] Saving image..." << std::endl;
	
	try
	{
		heightImage.save(pathHeightfield);
	}
	catch (std::exception& e)
	{
		std::cerr << e.what();
	}

	std::cout << "[Image] Generating color&normal..." << std::endl;

	GEDUtils::TextureGenerator tg(std::wstring(L"../../../../external/textures/gras15.jpg"),
		std::wstring(L"../../../../external/textures/ground02.jpg"),
		std::wstring(L"../../../../external/textures/pebble03.jpg"),
		std::wstring(L"../../../../external/textures/rock5.jpg"));

	tg.generateAndStoreImages(pic, resolution, pathColor, pathNormal);
	
	
	return 0;
}